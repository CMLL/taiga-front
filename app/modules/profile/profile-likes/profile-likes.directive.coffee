ProfileLikesDirective = () ->
    return {
        scope: {},
        bindToController: {
            user: "="
            type: "@"
            q: "@"
        }
        controller: "ProfileLikes",
        controllerAs: "vm",
        templateUrl: "profile/profile-likes/profile-likes.html",
    }

angular.module("taigaProfile").directive("tgProfileLikes", ProfileLikesDirective)
