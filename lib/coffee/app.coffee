angular.module('MyApp', ['DocumentService', 'LockService', 'EntityService', 'SessionService', 'UserService', 'RequestService', 'ngCookies']).
  config(['$routeProvider', ($route) ->
    $route.when('/home', templateUrl: '/partials/home/home.html')
    $route.when('/register',
      templateUrl: '/partials/users/registration.html',
      controller: UserRegistrationCtrl)
    $route.when('/login',
      templateUrl: '/partials/users/login.html',
      controller: UserLoginCtrl)
    $route.when('/me',
      templateUrl: '/partials/users/me.html',
      controller: UserMeCtrl)
    $route.when('/password_reset',
      templateUrl: '/partials/users/password_reset.html',
      controller: UserPasswordResetCtrl)
    $route.when('/request-list', 
      templateUrl: '/partials/request/request-list.html',
      controller: RequestListCtrl)
    $route.when('/request-form/:requestId',
      templateUrl: '/partials/request/request-form.html',
      controller: RequestFormCtrl)
    $route.when('/entity-list',
      templateUrl: '/partials/entities/entity-list.html',
      controller: EntitiesListCtrl)
    $route.when('/lock-list/:documentId',
      templateUrl: '/partials/locks/lock-list.html',
      controller: LocksListCtrl)
    $route.otherwise({redirectTo: '/home'})
  ])
.config(($httpProvider) ->
	interceptor = ['$rootScope','$q', (scope, $q) ->
    	success = (response) ->
        	response
      	error = (response) ->
        	status = response.status
        	if status is 401
          		deferred = $q.defer()
          		req =
            		config: response.config
            		deferred: deferred
          		scope.requests401 = req
          		scope.$broadcast('event:loginRequired')
          		return deferred.promise
        	$q.reject(response)
      	(promise) ->
        	promise.then(success, error)
    ]
    $httpProvider.responseInterceptors.push(interceptor);
)
.run(['$http', '$rootScope', '$location','$cookieStore', 'User', 'Session',
      ($http, scope, $location, $cookieStore, User, Session) ->
        scope.requests401 = '/me'
        scope.$on('event:loginRequired',(event) ->
          $cookieStore.put('signed_in', false)
          $location.path('/login')
        ) 
        scope.$on("event:loginConfirmed", (event) ->
          $cookieStore.put('signed_in', true)
          $location.path(scope.requests401) if $location.path() is "/login"
        )
        scope.$on('event:logoutRequest', (event) ->
          result = Session.logout () ->
            console.log('logout request')
            if result.status is 'ok'
              scope.$broadcast('event:logoutConfirmed')
        )
        scope.$on('event:logoutConfirmed', (event) ->
          $cookieStore.put('signed_in', false)
          $location.path('/login')
        )

        $http.get('users/status').success((data) ->
        	if data.status is 'ok'
        		$cookieStore.put('signed_in', true)
        	else
        		$cookieStore.put('signed_in', false)
        )
])