taiga = @.taiga

class UserService extends taiga.Service
    @.$inject = ["tgResources"]

    constructor: (@rs) ->

    getUserByUserName: (username) ->
        return @rs.users.getUserByUsername(username)

    getContacts: (userId) ->
        return @rs.users.getContacts(userId)

    getLikes: (userId, pageNumber, objectType, textQuery) ->
        return @rs.users.getLikes(userId, pageNumber, objectType, textQuery)

    getWatched: (userId, pageNumber, objectType, textQuery) ->
        return @rs.users.getWatched(userId, pageNumber, objectType, textQuery)

    getStats: (userId) ->
        return @rs.users.getStats(userId)

    attachUserContactsToProjects: (userId, projects) ->
        return @.getContacts(userId)
            .then (contacts) ->
                projects = projects.map (project) ->
                    contactsFiltered = contacts.filter (contact) ->
                        contactId = contact.get("id")
                        return project.get('members').indexOf(contactId) != -1

                    project = project.set("contacts", contactsFiltered)

                    return project

                return projects

angular.module("taigaCommon").service("tgUserService", UserService)
