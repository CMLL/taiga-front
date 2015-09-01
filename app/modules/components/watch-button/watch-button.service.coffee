taiga = @.taiga

class WatchButtonService extends taiga.Service
    @.$inject = ["tgResources"]

    constructor: (@rs) ->

    watch: (project) ->
        return @rs.projects.watchProject(project.get("id")).then ->
            return project.merge({
                is_watched: true,
                watchers: project.get("watchers") + 1
            })

    unwatch: (project) ->
        return @rs.projects.unwatchProject(project.get("id")).then ->
            return project.merge({
                is_watched: false,
                watchers: project.get("watchers") - 1
            })

angular.module("taigaComponents").service("tgWatchButtonService", WatchButtonService)
