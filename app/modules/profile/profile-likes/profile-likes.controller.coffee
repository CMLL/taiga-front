class ProfileLikesController
    @.$inject = [
        "tgUserService",
        "tgCurrentUserService"
    ]

    constructor: (@userService, @currentUserService) ->

    loadLikes: () ->
        @userService.getLikes(@.user.get("id"))
            .then (likes) =>
                @.likes = likes


angular.module("taigaProfile")
    .controller("ProfileLikes", ProfileLikesController)

