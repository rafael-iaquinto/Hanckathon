(function () {
    'use strict';
    angular
        .module(global.config.APP_NAME)
        .controller('TasksController', Controller);

    Controller.$inject = ['$state', '$scope', 'TaskService', 'TaskModal'];

    function Controller($state, $scope, TaskService, TaskModal) {
        var controller = this;

        controller.tasks = [];
        controller.haveMore = false;

        $scope.$on('appReady', function() {
            controller.init();
        });

        $scope.$on('actionMenuClicked', function() {
            TaskModal.show()
            .then(function(newTask) {
                TaskService.addTask(newTask);
            });
        })

        controller.init = function() {
            console.log("controller initiated");
        }

        controller.openGraph = function(task) {
            $state.go('tasks.detail', { taskId : task._id } );
        }

        controller.updateTasks = function() {
            TaskService.getTasksList().then(function(result){
                console.log(result);
                controller.tasks = result.tasks;
            });
        }

        controller.enterSearchKey = function(keyEvent) {
            if (keyEvent.which === 13) {
                document.getElementById("search").blur();
            }
        }
        
        controller.updateTasks();
    }
}());
