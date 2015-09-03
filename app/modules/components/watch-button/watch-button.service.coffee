taiga = @.taiga

class WatchButtonService extends taiga.Service
    @.$inject = [
        "tgResources",
        "tgCurrentUserService"
    ]

    constructor: (@rs, @currentUserService) ->

    watch: (project, notifyLevel) ->
        return @rs.projects.watchProject(project.get("id"), notifyLevel).then =>
            watchers = project.get("watchers").toJS()
            watchers = _.union(watchers, [@currentUserService.getUser().get("id")])

            return project.merge({
                is_watched: true,
                watchers: watchers
                notify_level: notifyLevel
            })

    unwatch: (project) ->
        return @rs.projects.unwatchProject(project.get("id")).then =>
            watchers = project.get("watchers").toJS()
            watchers = _.without(watchers, @currentUserService.getUser().get("id"))

            return project.merge({
                is_watched: false,
                watchers: watchers
                notify_level: null
            })

angular.module("taigaComponents").service("tgWatchButtonService", WatchButtonService)
