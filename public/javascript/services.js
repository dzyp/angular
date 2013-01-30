(function() {

  angular.module('SessionService', ['ngResource']).factory('Session', function($resource) {
    return $resource('/users/session', {}, {
      login: {
        method: 'POST'
      },
      logout: {
        method: 'DELETE'
      }
    });
  });

  angular.module('UserService', ['ngResource']).factory('User', function($resource) {
    var User;
    return User = $resource('/users', {}, {
      register: {
        method: 'POST'
      },
      me: {
        method: 'GET'
      },
      update: {
        method: 'PUT'
      }
    });
  });

  angular.module('RequestService', ['ngResource']).factory('Request', function($resource) {
    var Request;
    return Request = $resource('/requests/:requestId', {}, {
      query: {
        method: 'GET',
        params: {
          requestId: ''
        },
        isArray: true
      }
    });
  });

  angular.module('EntityService', ['ngResource']).factory('Entity', function($resource) {
    var Entity;
    return Entity = $resource('/entities/:entityId', {}, {
      query: {
        method: 'GET',
        params: {
          entityId: ''
        },
        isArray: true
      }
    });
  });

  angular.module('LockService', ['ngResource']).factory('Lock', function($resource) {
    var Lock;
    return Lock = $resource('/locks/:documentId');
  });

  angular.module('DocumentService', ['ngResource']).factory('Document', function($resource) {
    var Document;
    return Document = $resource('/documents/:documentId', {}, {
      query: {
        method: 'GET',
        params: {
          documentId: ''
        },
        isArray: true
      }
    });
  });

}).call(this);
