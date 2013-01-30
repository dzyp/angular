angular.module('SessionService',['ngResource']).
	factory('Session', ($resource) ->
    	$resource(
      		'/users/session', 
      		{},
      		login:{method: 'POST'},
      		logout:{method: 'DELETE'}
    	)
  	)

angular.module('UserService', ['ngResource']).
  factory('User', ($resource) ->
    User = $resource('/users', {},
      {
        register:{method: 'POST'},
        me:{method: 'GET'},
        update:{method: 'PUT'}
      })
  )
  
angular.module('RequestService', ['ngResource']).
  factory('Request', ($resource) ->
    Request = $resource('/requests/:requestId', {},
      {
        query: {method:'GET', params:{requestId: ''}, isArray:true}
      })
  )
    
angular.module('EntityService', ['ngResource'])
  .factory('Entity', ($resource) ->
    Entity = $resource('/entities/:entityId', {},
      {
        query: {method:'GET', params:{entityId: ''}, isArray:true}
      })
  )
  
angular.module('LockService', ['ngResource'])
  .factory('Lock', ($resource) ->
    Lock = $resource('/locks/:documentId')
  )
  
angular.module('DocumentService', ['ngResource'])
  .factory('Document', ($resource) ->
    Document = $resource('/documents/:documentId', {},
      {
        query: {method:'GET', params:{documentId: ''}, isArray:true}
      })
  )