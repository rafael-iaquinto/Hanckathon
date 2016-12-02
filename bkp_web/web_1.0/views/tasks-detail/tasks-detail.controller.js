(function () {
    'use strict';
    angular
        .module(global.config.APP_NAME)
        .controller('TaskDetailController', Controller);

    Controller.$inject = [
        '$scope',
        '$stateParams',
        '$filter',
        'TaskService',
        '$http',
        '$state'
    ];

    function Controller($scope, $stateParams, $filter, TaskService ) {
        var controller = this;

        // Controle de animação pois esta tela é de detalhes, e deve deslizar do lado, e não fazer o fade padrão.
        controller.anim = 'anim-slide-left';
        $scope.$on('animEnd', function($event, element, speed) {
            controller.anim = 'anim-slide-right';
        });

        controller.task = TaskService.getTask($stateParams.taskId);

        var payload = {
            "finished" : true
            };

         var options = {
                headers : {
                    'authorization' : 'rafael'
                }
            };

        controller.save = function() {
             
             $http.put("http://spon5044.sp01.local:8003/api/tasks" + controller.tasks._id, options, payload)
                .success(function(result){
                    //service.tasks = result.tasks;                    
                    //deferred.resolve(result);
                    console.log(result);
                    $state.go('tasks')
                })
                .error(function(error){
                    //deferred.reject(error)
                    console.log(result);
                });
        }


        controller.task = TaskService.getTask($stateParams.taskId);
    }
}());
