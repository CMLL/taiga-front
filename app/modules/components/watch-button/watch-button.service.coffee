taiga = @.taiga

class WatchButtonService extends taiga.Service
    @.$inject = [
        "tgResources",
        "tgCurrentUserService"
    ]

    constructor: (@rs, @currentUserService) ->

    watch: (project, notifyPolicy) ->
        return @rs.projects.watchProject(project.get("id"), notifyPolicy).then =>
            watchers = project.get("watchers").toJS()
            watchers = _.union(watchers, [@currentUserService.getUser().get("id")])

            return project.merge({
                is_watched: true,
                watchers: watchers
                notify_policy: notifyPolicy
            })

    unwatch: (project) ->
        return @rs.projects.unwatchProject(project.get("id")).then =>
            watchers = project.get("watchers").toJS()
            watchers = _.without(watchers, @currentUserService.getUser().get("id"))

            return project.merge({
                is_watched: false,
                watchers: watchers
            })

angular.module("taigaComponents").service("tgWatchButtonService", WatchButtonService)
