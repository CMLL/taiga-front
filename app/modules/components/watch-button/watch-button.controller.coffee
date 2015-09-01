class WatchButtonController
    @.$inject = [
        "$tgConfirm"
        "tgWatchButtonService"
    ]

    constructor: (@confirm, @watchButtonService)->
        @.showWatchOptions = false


angular.module("taigaComponents").controller("WatchButton", WatchButtonController)
