taiga = @.taiga

class LikeButtonService extends taiga.Service
    @.$inject = ["tgResources", "tgCurrentUserService", "tgProjectService"]

    constructor: (@rs, @currentUserService, @projectService) ->

    _getProjectIndex: (projectId) ->
        return @currentUserService.projects
                .get('all')
                .findIndex (project) -> project.get('id') == projectId

    _updateProjects: (projectId, is_liked) ->
        projectIndex = @._getProjectIndex(projectId)
        projects = @currentUserService.projects
            .get('all')
            .update projectIndex, (project) ->

                likes = project.get("likes")

                if is_liked then likes++ else likes--

                return project.merge({
                    is_liked: is_liked,
                    likes: likes
                })

        @currentUserService.setProjects(projects)

    _updateCurrentProject: (is_liked) ->
        likes = @projectService.project.get("likes")

        if is_liked then likes++ else likes--

        project = @projectService.project.merge({
            is_liked: is_liked,
            likes: likes
        })

        @projectService.setProject(project)

    like: (projectId) ->
        return @rs.projects.likeProject(projectId).then =>
            @._updateProjects(projectId, true)
            @._updateCurrentProject(true)

    unlike: (projectId) ->
        return @rs.projects.unlikeProject(projectId).then =>
            @._updateProjects(projectId, false)
            @._updateCurrentProject(false)

angular.module("taigaComponents").service("tgLikeButtonService", LikeButtonService)
