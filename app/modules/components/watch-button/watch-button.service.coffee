taiga = @.taiga

class WatchButtonService extends taiga.Service
    @.$inject = [
        "tgResources",
        "tgCurrentUserService",
        "tgProjectService"
    ]

    constructor: (@rs, @currentUserService, @projectService) ->

    _getProjectIndex: (projectId) ->
        return @currentUserService.projects
                .get('all')
                .findIndex (project) -> project.get('id') == projectId


    _updateProjects: (projectId, notifyLevel, is_watched) ->
        userId = @currentUserService.getUser().get("id")
        projectIndex = @._getProjectIndex(projectId)

        projects = @currentUserService.projects
            .get('all')
            .update projectIndex, (project) =>
                watchers = project.get('watchers')

                if is_watched && !watchers.includes(userId)
                    watchers = watchers.push(userId)
                else if !is_watched
                    watchers = watchers.filterNot (watcher) -> watcher == userId

                return project.merge({
                    is_watched: true,
                    watchers: watchers
                    notify_level: notifyLevel
                })

        @currentUserService.setProjects(projects)

    _updateCurrentProject: (notifyLevel, is_watched) ->
        userId = @currentUserService.getUser().get("id")
        watchers = @projectService.project.get("watchers")

        if is_watched && !watchers.includes(userId)
            watchers = watchers.push(userId)
        else if !is_watched
            watchers = watchers.filterNot (watcher) -> watcher == userId

        project = @projectService.project.merge({
            is_watched: is_watched,
            watchers: watchers
            notify_level: notifyLevel
        })

        @projectService.setProject(project)

    watch: (projectId, notifyLevel) ->
        return @rs.projects.watchProject(projectId, notifyLevel).then =>
            @._updateProjects(projectId, notifyLevel, true)
            @._updateCurrentProject(notifyLevel, true)

    unwatch: (projectId) ->
        return @rs.projects.unwatchProject(projectId).then =>
            @._updateProjects(projectId, null, false)
            @._updateCurrentProject(null, false)

angular.module("taigaComponents").service("tgWatchButtonService", WatchButtonService)
