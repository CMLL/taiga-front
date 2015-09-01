WatchButtonDirective = ->
    return {
        scope: {}
        controller: "WatchButton",
        bindToController: {
            project: "="
        }
        controllerAs: "vm",
        templateUrl: "components/watch-button/watch-button.html",
    }

angular.module("taigaComponents").directive("tgWatchButton", WatchButtonDirective)
