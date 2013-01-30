@NavCtrl = ($scope, $rootScope, $location, $cookieStore, Session) ->
   $scope.authenticated = () ->
     $cookieStore.get('signed_in')
   $scope.logout = () ->
     $rootScope.$broadcast('event:logoutRequest')

@UserRegistrationCtrl = ($scope, $rootScope, $location, $cookieStore, User)->
  $scope.register =  () ->
    $scope.response = User.register {user: $scope.User}, () ->
      if $scope.response.status is 'ok'
        $rootScope.$broadcast('event:loginConfirmed')
      else
        alert($scope.response.error)

@RequestListCtrl = ($scope, Request) ->
	$scope.requests = Request.query()

@UserMeCtrl = ($scope, $http, User) ->
   response = User.me({}, () ->
     $scope.User = response.user
   )
   $scope.reset_access_token = () ->
     $http.put("/users/access_token").
       success((data) ->
         $scope.User.access_token = data.access_token
       )


@UserLoginCtrl = ($scope, $rootScope, $location, $cookieStore, Session) ->
  $scope.login = () ->
    $scope.response = Session.login $scope.Session, () ->
      if $scope.response.status is 'ok'
        $rootScope.$broadcast('event:loginConfirmed')
      else
        alert($scope.response.error)
    
@UserPasswordResetCtrl = ($scope, $location, $http, User) ->
  $scope.reset = () ->
    $http.put('/users/password', $scope.User).
      success((data) ->
        if data.status is 'ok'
          $location.path('/me')
          alert('Password Reset done')
        else
          alert(data.error)
        )
        
@HomeCtrl = ($scope) ->

@RequestFormCtrl = ($scope, $location, $routeParams, Request) ->
  $scope.request = {}
  $scope.copy = {}
  id = $routeParams.requestId
	
  if id
    Request.get({requestId: id}, (response) ->
      if response.status is 'ok'
        $scope.request = response.data
        $scope.reset()
    )
  $scope.reset = () ->
    $scope.request = angular.copy $scope.copy
		
  $scope.save = (request) ->
    Request.save({request: request}, (response) ->
      if response.status is 'ok'
        $location.path('/request-list')
      else
        $scope.copy.errors = response.errors
        reset()
    )
  
  $scope.hasErrors = () ->
    $scope.request.errors
	
@EntitiesListCtrl = ($scope, Entity) ->
  $scope.entities = Entity.query()
  
@LocksListCtrl = ($scope, $routeParams, Lock, Document) ->
  new LockAPI(Lock, Document).getLocksByEntityId($routeParams.documentId).subscribe((arr) ->
    $scope.locks = arr[0]
    $scope.document = arr[0]
  )
  