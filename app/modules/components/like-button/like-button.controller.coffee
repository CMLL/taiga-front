class LikeButtonController
    @.$inject = [
        "$tgConfirm"
        "tgLikeButtonService"
    ]

    constructor: (@confirm, @likeButtonService)->

    toggleLike: ->
        if not @.project.get("is_liked")
            @._like()
        else
            @._unlike()

    _like: ->
        onSuccess = (project) =>
            @.project = project
        onError = =>
            @confirm.notify("error")
        @likeButtonService.like(@.project).then(onSuccess, onError)

    _unlike: ->
        onSuccess = (project) =>
            @.project = project
        onError = =>
            @confirm.notify("error")
        @likeButtonService.unlike(@.project).then(onSuccess, onError)

angular.module("taigaComponents").controller("LikeButton", LikeButtonController)
