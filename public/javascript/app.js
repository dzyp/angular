(function() {

  angular.module('MyApp', ['DocumentService', 'LockService', 'EntityService', 'SessionService', 'UserService', 'RequestService', 'ngCookies']).config([
    '$routeProvider', function($route) {
      $route.when('/home', {
        templateUrl: '/partials/home/home.html'
      });
      $route.when('/register', {
        templateUrl: '/partials/users/registration.html',
        controller: UserRegistrationCtrl
      });
      $route.when('/login', {
        templateUrl: '/partials/users/login.html',
        controller: UserLoginCtrl
      });
      $route.when('/me', {
        templateUrl: '/partials/users/me.html',
        controller: UserMeCtrl
      });
      $route.when('/password_reset', {
        templateUrl: '/partials/users/password_reset.html',
        controller: UserPasswordResetCtrl
      });
      $route.when('/request-list', {
        templateUrl: '/partials/request/request-list.html',
        controller: RequestListCtrl
      });
      $route.when('/request-form/:requestId', {
        templateUrl: '/partials/request/request-form.html',
        controller: RequestFormCtrl
      });
      $route.when('/entity-list', {
        templateUrl: '/partials/entities/entity-list.html',
        controller: EntitiesListCtrl
      });
      $route.when('/lock-list/:documentId', {
        templateUrl: '/partials/locks/lock-list.html',
        controller: LocksListCtrl
      });
      return $route.otherwise({
        redirectTo: '/home'
      });
    }
  ]).config(function($httpProvider) {
    var interceptor;
    interceptor = [
      '$rootScope', '$q', function(scope, $q) {
        var error, success;
        success = function(response) {
          return response;
        };
        error = function(response) {
          var deferred, req, status;
          status = response.status;
          if (status === 401) {
            deferred = $q.defer();
            req = {
              config: response.config,
              deferred: deferred
            };
            scope.requests401 = req;
            scope.$broadcast('event:loginRequired');
            return deferred.promise;
          }
          return $q.reject(response);
        };
        return function(promise) {
          return promise.then(success, error);
        };
      }
    ];
    return $httpProvider.responseInterceptors.push(interceptor);
  }).run([
    '$http', '$rootScope', '$location', '$cookieStore', 'User', 'Session', function($http, scope, $location, $cookieStore, User, Session) {
      scope.requests401 = '/me';
      scope.$on('event:loginRequired', function(event) {
        $cookieStore.put('signed_in', false);
        return $location.path('/login');
      });
      scope.$on("event:loginConfirmed", function(event) {
        $cookieStore.put('signed_in', true);
        if ($location.path() === "/login") {
          return $location.path(scope.requests401);
        }
      });
      scope.$on('event:logoutRequest', function(event) {
        var result;
        return result = Session.logout(function() {
          console.log('logout request');
          if (result.status === 'ok') {
            return scope.$broadcast('event:logoutConfirmed');
          }
        });
      });
      scope.$on('event:logoutConfirmed', function(event) {
        $cookieStore.put('signed_in', false);
        return $location.path('/login');
      });
      return $http.get('users/status').success(function(data) {
        if (data.status === 'ok') {
          return $cookieStore.put('signed_in', true);
        } else {
          return $cookieStore.put('signed_in', false);
        }
      });
    }
  ]);

}).call(this);
