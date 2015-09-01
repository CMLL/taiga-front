LikeButtonDirective = ->
    return {
        scope: {}
        controller: "LikeButton",
        bindToController: {
            project: '='
        }
        controllerAs: "vm",
        templateUrl: "components/like-button/like-button.html",
    }

angular.module("taigaComponents").directive("tgLikeButton", LikeButtonDirective)
