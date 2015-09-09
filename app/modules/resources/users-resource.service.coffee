Resource = (urlsService, http, paginateResponseService) ->
    service = {}

    service.getUserByUsername = (username) ->
        url = urlsService.resolve("by_username")

        httpOptions = {
            headers: {
                "x-disable-pagination": "1"
            }
        }

        params = {
            username: username
        }

        return http.get(url, params, httpOptions)
            .then (result) ->
                return Immutable.fromJS(result.data)

    service.getStats = (userId) ->
        url = urlsService.resolve("user-stats", userId)

        httpOptions = {
            headers: {
                "x-disable-pagination": "1"
            }
        }

        return http.get(url, {}, httpOptions)
            .then (result) ->
                return Immutable.fromJS(result.data)

    service.getContacts = (userId) ->
        url = urlsService.resolve("user-contacts", userId)

        httpOptions = {
            headers: {
                "x-disable-pagination": "1"
            }
        }

        return http.get(url, {}, httpOptions)
            .then (result) ->
                return Immutable.fromJS(result.data)

    service.getLikes = (userId, objectType, textQuery, pageNumber) ->
        url = urlsService.resolve("user-likes", userId)

        params = {action: "vote"}
        params.type = objectType if objectType?
        params.q = textQuery if textQuery?

        return http.get(url, params)
            .then (result) ->
                return Immutable.fromJS(result.data)

    service.getWatched = (userId, page, type, q) ->
        url = urlsService.resolve("user-watched", userId)

        params = {action: "watch"}
        params.type = objectType if objectType?
        params.q = textQuery if textQuery?

        return http.get(url, params)
            .then (result) ->
                return Immutable.fromJS(result.data)

    service.getProfileTimeline = (userId, page) ->
        params = {
            page: page
        }

        url = urlsService.resolve("timeline-profile")
        url = "#{url}/#{userId}"

        return http.get(url, params).then (result) ->
            result = Immutable.fromJS(result)
            return paginateResponseService(result)

    service.getUserTimeline = (userId, page) ->
        params = {
            page: page
        }

        url = urlsService.resolve("timeline-user")
        url = "#{url}/#{userId}"

        return http.get(url, params).then (result) ->
            result = Immutable.fromJS(result)
            return paginateResponseService(result)

    return () ->
        return {"users": service}

Resource.$inject = ["$tgUrls", "$tgHttp", "tgPaginateResponseService"]

module = angular.module("taigaResources2")
module.factory("tgUsersResources", Resource)
