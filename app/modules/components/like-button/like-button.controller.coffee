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
        return @likeButtonService.like(@.project.get('id')).catch () =>
            @confirm.notify("error")

    _unlike: ->
        return @likeButtonService.unlike(@.project.get('id')).catch () =>
            @confirm.notify("error")

angular.module("taigaComponents").controller("LikeButton", LikeButtonController)
