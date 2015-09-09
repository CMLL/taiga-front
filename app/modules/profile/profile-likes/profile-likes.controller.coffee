class ProfileLikesController
    @.$inject = [
        "tgUserService",
    ]

    constructor: (@userService) ->

    loadLikes: () ->
        @userService.getLikes(@.user.get("id"))
            .then (likes) =>
                @.likes = likes


angular.module("taigaProfile")
    .controller("ProfileLikes", ProfileLikesController)

