(function () {
    'use strict';
    angular
    .module(global.config.APP_NAME)
    .service('TaskService', Service);

    Service.$inject = ['$q', '$uibModal' , '$http' ];

    function Service($q, $uibModal, $http) {
        var service = this;

        service.tasks = [];

        service.getTasksList = function() {
            
            var options = {
                headers : {
                    'authorization' : 'rafael'
                }
            };

            var deferred = $q.defer();

            $http.get("http://spon5044.sp01.local:8003/api/tasks", options)
                .success(function(result){
                    service.tasks = result.tasks;                    
                    deferred.resolve(result);
                })
                .error(function(error){
                    deferred.reject(error)
                });

            return deferred.promise;
        }

        service.addTask = function(task) {
            if( !task || !task.name || !task.date )
                return null;

            var id = service.tasks.length + 1;

            task.id = id;

            task.uDate = service.beautify(task.date);

            service.tasks.unshift(task);
            return task;
        }

        service.beautify = function(data) {
            var data = new Date(data);
            var dia = data.getDate();

            if (dia.toString().length == 1)
              dia = "0"+dia;

            var mes = data.getMonth()+1;
            if (mes.toString().length == 1)
              mes = "0"+mes;

            var ano = data.getFullYear();

            return dia+"/"+mes+"/"+ano;
        }

        service.completeTask = function(taskIndex) {
            service.tasks.splice(taskIndex, 1);
        }

        service.getTask = function(taskId) {
            for(var i = 0; i < service.tasks.length; i++ ) {
                if( service.tasks[i]._id == taskId ) {
                    return service.tasks[i];
                }
            }
            return null;
        }
    }

}());
