(function() {

  this.NavCtrl = function($scope, $rootScope, $location, $cookieStore, Session) {
    $scope.authenticated = function() {
      return $cookieStore.get('signed_in');
    };
    return $scope.logout = function() {
      return $rootScope.$broadcast('event:logoutRequest');
    };
  };

  this.UserRegistrationCtrl = function($scope, $rootScope, $location, $cookieStore, User) {
    return $scope.register = function() {
      return $scope.response = User.register({
        user: $scope.User
      }, function() {
        if ($scope.response.status === 'ok') {
          return $rootScope.$broadcast('event:loginConfirmed');
        } else {
          return alert($scope.response.error);
        }
      });
    };
  };

  this.RequestListCtrl = function($scope, Request) {
    return $scope.requests = Request.query();
  };

  this.UserMeCtrl = function($scope, $http, User) {
    var response;
    response = User.me({}, function() {
      return $scope.User = response.user;
    });
    return $scope.reset_access_token = function() {
      return $http.put("/users/access_token").success(function(data) {
        return $scope.User.access_token = data.access_token;
      });
    };
  };

  this.UserLoginCtrl = function($scope, $rootScope, $location, $cookieStore, Session) {
    return $scope.login = function() {
      return $scope.response = Session.login($scope.Session, function() {
        if ($scope.response.status === 'ok') {
          return $rootScope.$broadcast('event:loginConfirmed');
        } else {
          return alert($scope.response.error);
        }
      });
    };
  };

  this.UserPasswordResetCtrl = function($scope, $location, $http, User) {
    return $scope.reset = function() {
      return $http.put('/users/password', $scope.User).success(function(data) {
        if (data.status === 'ok') {
          $location.path('/me');
          return alert('Password Reset done');
        } else {
          return alert(data.error);
        }
      });
    };
  };

  this.HomeCtrl = function($scope) {};

  this.RequestFormCtrl = function($scope, $location, $routeParams, Request) {
    var id;
    $scope.request = {};
    $scope.copy = {};
    id = $routeParams.requestId;
    if (id) {
      Request.get({
        requestId: id
      }, function(response) {
        if (response.status === 'ok') {
          $scope.request = response.data;
          return $scope.reset();
        }
      });
    }
    $scope.reset = function() {
      return $scope.request = angular.copy($scope.copy);
    };
    $scope.save = function(request) {
      return Request.save({
        request: request
      }, function(response) {
        if (response.status === 'ok') {
          return $location.path('/request-list');
        } else {
          $scope.copy.errors = response.errors;
          return reset();
        }
      });
    };
    return $scope.hasErrors = function() {
      return $scope.request.errors;
    };
  };

  this.EntitiesListCtrl = function($scope, Entity) {
    return $scope.entities = Entity.query();
  };

  this.LocksListCtrl = function($scope, $routeParams, Lock, Document) {
    return new LockAPI(Lock, Document).getLocksByEntityId($routeParams.documentId).subscribe(function(arr) {
      $scope.locks = arr[0];
      return $scope.document = arr[0];
    });
  };

}).call(this);
