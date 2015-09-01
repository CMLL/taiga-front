taiga = @.taiga

class LikeButtonService extends taiga.Service
    @.$inject = ["tgResources"]

    constructor: (@rs) ->

    like: (project) ->
        return @rs.projects.likeProject(project.get("id")).then ->
            return project.merge({
                is_liked: true,
                likes: project.get("likes") + 1
            })

    unlike: (project) ->
        return @rs.projects.unlikeProject(project.get("id")).then ->
            return project.merge({
                is_liked: false,
                likes: project.get("likes") - 1
            })

angular.module("taigaComponents").service("tgLikeButtonService", LikeButtonService)
