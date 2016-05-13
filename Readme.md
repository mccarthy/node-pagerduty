# pagerduty

A node.js client for PagerDuty.

## Install

```
npm install pagerduty
```

## Methods

### constructor(options)
  * Required:
    * `serviceKey` - The GUID of one of your “Generic API” services. This is the “service key” listed on a Generic API’s service detail page.

### create(options)
  * Required:
    * `description` - A short description of the problem that led to this trigger.
  * Optional:
    * `details` - An arbitrary JSON object containing any data you’d like included in the incident log.
    * `incidentKey` - Identifies the incident to which this trigger event should be applied.
    * `callback` - A Callback with two arguments `(err, response)`

### acknowledge(options)
  * Required:
    * `incidentKey` - Identifies the incident to which this trigger event should be applied.
  * Optional:
    * `details` - An arbitrary JSON object containing any data you’d like included in the incident log.
    * `description` - Text that will appear in the incident’s log associated with this event.
    * `callback` - A Callback with two arguments `(err, response)`

### resolve(options)
  * Required:
    * `incidentKey` - Identifies the incident to which this trigger event should be applied.
  * Optional:
    * `details` - An arbitrary JSON object containing any data you’d like included in the incident log.
    * `description` - Text that will appear in the incident’s log associated with this event.
    * `callback` - A Callback with two arguments `(err, response)`

### getIncident(options)
  * Required
    *`incidentKey` - Incident key to retrieve incidents for.
  * Optional
    * `status` - Filters incidents returned by status, for example 'triggered,acknowledged' will retrieve open incidents.

### Example response

```json
{ 
  status: 'success',
  incident_key: '87fb80301f99012f961a1231381bc5dc',
  message: 'Event processed'
}
```

## Usage

```javascript
var pager, PagerDuty;

PagerDuty = require('pagerduty');

pager = new PagerDuty({
  serviceKey: '12345678901234567890123456789012',
  subdomain: 'your-subdomain-here',
  apiToken: 'your-api-token-here'
});

pager.create({
  description: 'testError', // required
  details: {
    foo: 'bar'
  },
  callback: function(err, response) {
    if (err) throw err;
    var incidentKey = response.incident_key;
    pager.acknowledge({
      incidentKey: incidentKey, // required
      description: 'Got the test error!',
      details: {
        foo: 'bar'
      },
      callback: function(err, response) {
        if (err) throw err;

        pager.getIncident({incidentKey: incidentKey,
            status: 'triggered,acknowledged',
            callback: function(err, response) {
              if (err) throw err;
              console.log(response);

              pager.resolve({
              incidentKey: incidentKey, // required
              description: 'Resolved the test error!',
              details: {
                foo: 'bar'
              },
              callback: function(err, response) {
                if (err) throw err;
              }
            });
          }
        });
      }
    });
  }
});
```

## License

Licensed under the MIT license.
