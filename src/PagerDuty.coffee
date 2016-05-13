request = require 'request'

class PagerDuty
  module.exports = PagerDuty

  constructor: ({@serviceKey, @subdomain, @apiToken}) ->
    throw new Error 'PagerDuty.constructor: Need serviceKey!' unless @serviceKey?
    throw new Error 'PagerDuty.constructor: Need subdomain!' unless @subdomain?
    throw new Error 'PagerDuty.constructor: Need apiToken!' unless @apiToken?

  create: ({description, incidentKey, details, callback}) ->
    throw new Error 'PagerDuty.create: Need description!' unless description?

    @_request arguments[0] extends eventType: 'trigger'

  acknowledge: ({incidentKey, details, description, callback}) ->
    throw new Error 'PagerDuty.acknowledge: Need incidentKey!' unless incidentKey?

    @_request arguments[0] extends eventType: 'acknowledge'

  resolve: ({incidentKey, details, description, callback}) ->
    throw new Error 'PagerDuty.resolve: Need incidentKey!' unless incidentKey?

    @_request arguments[0] extends eventType: 'resolve'

  getIncident: ({incidentKey, status}) ->
    throw new Error 'PagerDuty.resolve: Need incidentKey!' unless incidentKey?

    @_request arguments[0] extends eventType: 'get'

  _request: ({description, incidentKey, eventType, details, status, callback}) ->
    throw new Error 'PagerDuty._request: Need eventType!' unless eventType?
    json = {}
    headers = {}
    uri = 'https://events.pagerduty.com/generic/2010-04-15/create_event.json'
    method = 'POST'
    incidentKey ||= null
    details     ||= {}
    callback    ||= ->
    status      ||= null

    if eventType == 'get'
      json.token = @apiToken
      uri = "https://#{@subdomain}.pagerduty.com/api/v1/incidents/"
      json.incident_key = incidentKey;
      json.status = status if status;
      method = 'GET'
      headers.Authorization = "Token token=#{@apiToken}"
    else
      json.service_key = @serviceKey
      json.event_type = eventType
      json.description = description
      json.details = details
      json.incident_key = incidentKey if incidentKey?

    request
      method: method
      uri: uri
      json: json
      headers: headers
    , (err, response, body) ->
      if err or response.statusCode != 200
        callback err || new Error(body.errors[0])
      else
        callback null, body
