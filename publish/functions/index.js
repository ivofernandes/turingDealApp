const functions = require("firebase-functions");
const https = require('https');
const url = require("url");
const request = require("request");
const cluster = require('cluster');
const throttle = require("tokenthrottle")({rate: config.max_requests_per_second});

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.helloWorld = functions.https.onRequest((request, response) => {
  processRequest(request, response);
});

/**
 * add CORS header
 * @param {*} req request
 * @param {*} res response
 */
function addCORSHeaders(req, res) {
  if (req.method.toUpperCase() === "OPTIONS") {
    if (req.headers["access-control-request-headers"]) {
      res.setHeader("Access-Control-Allow-Headers",
          req.headers["access-control-request-headers"]);
    }
  }

  if (req.headers["origin"]) {
    res.setHeader("Access-Control-Allow-Origin", req.headers["origin"]);
  } else {
    res.setHeader("Access-Control-Allow-Origin", "*");
  }
}

/**
 * Write the http response
 * @param {*} res response
 * @param {*} httpCode code
 * @param {*} body http response body
 */
function writeResponse(res, httpCode, body) {
  res.statusCode = httpCode;
  res.end(body);
}

const fetchRegex = /^\/fetch\/(.*)$/;
/**
 * Process the http request
 * @param {*} req request
 * @param {*} res response
 */
function processRequest(req, res) {
  addCORSHeaders(req, res);

  // Return options pre-flight requests right away
  if (req.method.toUpperCase() === "OPTIONS") {
    writeResponse(res, 204);
  }

  const result = fetchRegex.exec(req.url);

  const remoteURL = url.parse(decodeURI(result[1]));

  
}
