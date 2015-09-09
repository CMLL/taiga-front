ProfileLikesDirective = () ->
    link = (scope, elm, attrs, ctrl) ->
        ctrl.loadLikes()

    return {
        scope: {},
        bindToController: {
            user: "="
        }
        controller: "ProfileLikes",
        controllerAs: "vm",
        link: link,
        templateUrl: "profile/profile-likes/profile-likes.html",
    }

angular.module("taigaProfile").directive("tgProfileLikes", ProfileLikesDirective)
