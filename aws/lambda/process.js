//console.log('Loading event');
var AWS = require('aws-sdk');
var cloudwatch = new AWS.CloudWatch();
exports.handler = function(event, context) {
   //console.log(JSON.stringify(event, null, '  '));
   for(i = 0; i < event.Records.length; ++i) {
      encodedPayload = event.Records[i].kinesis.data;
      payload = new Buffer(encodedPayload, 'base64').toString('ascii');
//      console.log(payload);
      var res = payload.split(",");
      var datum = Date.parse(res[0]);
      //console.log(datum);
      var temp= res[1];
      var hum = res[2];
      var serial = res[3];
       var params = {
          MetricData: [
              {
                  MetricName: 'Temperature',
          Dimensions: [
              {
                   Name: 'Item', /* required */
                   Value: serial /* required */
              },
        /* more items */
          ],
                  Unit: 'Count',
                  Value: Number(temp),
                  Timestamp: new Date(datum)
              },
              {
                  MetricName: 'Humidity',
          Dimensions: [
              {
                   Name: 'Item', /* required */
                   Value: serial /* required */
              },
        /* more items */
          ],
                  Unit: 'Count',
                  Value: Number(hum),
                  Timestamp: new Date(datum)
              },
          ],
          Namespace: 'HiveName'
      };
	var ret = cloudwatch.putMetricData(params, function(err, data) {
	   if (err)
	   {
	       console.log(err, err.stack); // an error occurred
	       context.done(null,"ERR");
	   }
	   else
	   {
//	       console.log(data);           // successful response
	       context.done(null,"OK");
	   }
	});
//	console.log(ret);
}
};