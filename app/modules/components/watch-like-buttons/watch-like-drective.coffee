taiga = @.taiga

WatchLikeDirective = () ->
    link = ($scope, $el, $attrs) ->
        $scope.vm = {}
        $scope.vm.toggleLike = false;
        $scope.vm.toggleWatch = false;

    return {
        scope: {},
        templateUrl: "components/watch-like-buttons/watch-like.html",
        link: link
    }

angular.module("taigaComponents").directive("tgWatchLike", WatchLikeDirective)
