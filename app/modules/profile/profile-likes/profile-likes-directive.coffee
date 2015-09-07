ProfileLikesDirective = () ->
    return {
        templateUrl: "profile/profile-likes/profile-likes.html",
        scope: {
            user: "="
        }
    }

angular.module("taigaProfile").directive("tgProfileLikes", ProfileLikesDirective)
