(function () {
    'use strict';
    angular
    .module(global.config.APP_NAME)
    .controller('SettingsController', Controller);

    Controller.$inject = [
        '$scope',
        '$filter',
        '$state',
        'NotificationService'
    ];

    function Controller($scope, $filter, $state, NotificationService) {
        var controller = this;

    }
}());
