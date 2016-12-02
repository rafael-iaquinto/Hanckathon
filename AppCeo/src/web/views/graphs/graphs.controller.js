(function () {
    'use strict';
    angular
        .module(global.config.APP_NAME)
        .controller('GraphsController', Controller);

    Controller.$inject = ['$state', '$scope', 'GraphService', 'GraphModal'];

    function Controller($state, $scope, GraphService, GraphModal) {
        var controller = this;

        controller.graph = [];
        controller.haveMore = false;

        $scope.$on('appReady', function() {
            controller.init();
        });       

        controller.init = function() {
            console.log("controller initiated");
        }

        controller.openGraph= function(graphCode) {
            $state.go('graphs.detail',{ graphs : graphCode });
        }

        
        //controller.updateGraps();
    }
}());
