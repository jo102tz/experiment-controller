/**
 * Copyright 2017 Joakim von Kistowski
 * <p>
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * <p>
 * http://www.apache.org/licenses/LICENSE-2.0
 * <p>
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package tools.descartes.dlim.httploadgenerator.http;

import org.eclipse.jetty.client.api.ContentResponse;
import org.eclipse.jetty.client.api.Request;
import tools.descartes.dlim.httploadgenerator.generator.ResultTracker;
import tools.descartes.dlim.httploadgenerator.transaction.Transaction;
import tools.descartes.dlim.httploadgenerator.transaction.TransactionDroppedException;
import tools.descartes.dlim.httploadgenerator.transaction.TransactionInvalidException;
import tools.descartes.dlim.httploadgenerator.transaction.TransactionQueueSingleton;

import java.io.EOFException;
import java.util.Optional;
import java.util.concurrent.CancellationException;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeoutException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * HTTP transaction sends HTML requests to a HTTP web server based on a LUA script.
 *
 * @author Joakim von Kistowski, Maximilian Deffner, Martin Straesser
 *
 */
public class HTTPTransaction extends Transaction {


    private static final String POST_SIGNAL = "[POST]";

    /** The constant logging instance. */
    private static final Logger LOG = Logger.getLogger(HTTPTransaction.class.getName());

    /**
     * Processes the transaction of sending a GET request to a web server.
     * @param generator The input generator to use.
     * @return Response time in milliseconds.
     */
    public long process(HTTPInputGenerator generator) throws TransactionDroppedException, TransactionInvalidException {
        long processStartTime = System.currentTimeMillis();
        if (generator.getTimeout() > 0 && processStartTime - getStartTime() > generator.getTimeout()) {
            throw new TransactionDroppedException("Wait time in queue too long. "
                    + String.valueOf(processStartTime - getStartTime()) + " ms passed before transaction was even started.");
        }
        String url = generator.getNextInput().trim();
        String method = "GET";
        Optional<String> payload = Optional.empty();
        if (url.startsWith("[")) {
            if (url.startsWith(POST_SIGNAL)) {
                method = "POST";
            }
            url = url.replaceFirst("\\[.*\\]", "");

            // Check whether JSON payload is specified
            if (url.startsWith("{")) {
                String jsonPayload = url.replaceAll("\\{(.*)\\}.*[^\\}]", "$1");
                payload = Optional.of(jsonPayload);
                url = url.replaceAll("\\{.*\\}(.*[^\\}])", "$1");
            }
        }

        //DEBUG
        //LOG.info("Request to: " + url);

        Request request = generator.initializeHTTPRequest(url, method, payload);

        try {
            ContentResponse response = request.send();
            if (response.getStatus() >= 400) {
                generator.revertLastCall();
                //DEBUG
                //LOG.info("Received error message: " + response.getContentAsString());
                LOG.log(Level.FINEST, "Received error response code: " + response.getStatus());
                throw new TransactionInvalidException("Error code: " + response.getStatus());
            } else {
                String responseBody = response.getContentAsString();
                long responseTime = System.currentTimeMillis() - processStartTime;
                //DEBUG
                //if (!url.contains("verif")) LOG.info("responseBody: " + responseBody);
                //store result
                generator.resetHTMLFunctions(responseBody);
                return responseTime;
            }
        } catch (TimeoutException e) {
            LOG.log(Level.WARNING, "TimeoutException for call to " + url);
            //generator.revertLastCall();
        } catch (ExecutionException e) {
            if (!(e.getCause() instanceof EOFException)) {
                /*
                if (e.getCause() == null || !(e.getCause() instanceof TimeoutException)) {
                    LOG.log(Level.SEVERE, "ExecutionException in call for URL: " + url + "; Cause: " + e.getCause().toString());
                }
                 */
                LOG.log(Level.SEVERE, "ExecutionException in call for URL: " + url + "; Cause: " + e.getCause().toString());
                generator.revertLastCall();
                throw new TransactionInvalidException("ExecutionException: " + e.getMessage());
            } else {
                LOG.log(Level.SEVERE, "EOFException for URL: " + url);
                //generator.revertLastCall();
                throw new TransactionInvalidException("ExecutionException: " + e.getMessage());
            }
        } catch (CancellationException e) {
            LOG.log(Level.SEVERE, "CancellationException: " + url + "; " + e.getMessage());
            generator.revertLastCall();
            throw new TransactionInvalidException("CancellationException: " + e.getMessage());
        } catch (InterruptedException e) {
            LOG.log(Level.SEVERE, "InterruptedException: " + e.getMessage());
            generator.revertLastCall();
            throw new TransactionInvalidException("InterruptedException: " + e.getMessage());
        }
        return 0;
    }

    @Override
    public void run() {
        HTTPInputGenerator generator = HTTPInputGeneratorPool.getPool().takeFromPool();
        try {
            long responseTime = this.process(generator);
            ResultTracker.TRACKER.logTransaction(responseTime, ResultTracker.TransactionState.SUCCESS);
        } catch (TransactionDroppedException e) {
            ResultTracker.TRACKER.logTransaction(0, ResultTracker.TransactionState.DROPPED);
        } catch (TransactionInvalidException e) {
            ResultTracker.TRACKER.logTransaction(0, ResultTracker.TransactionState.FAILED);
        }
        HTTPInputGeneratorPool.getPool().releaseBackToPool(generator);
        TransactionQueueSingleton transactionQueue = TransactionQueueSingleton.getInstance();
        transactionQueue.addQueueElement(this);
    }
}
