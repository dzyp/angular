(function() {

  this.LockAPI = (function() {

    function LockAPI(Lock, Document) {
      this.lock = Lock;
      this.document = Document;
    }

    LockAPI.prototype.getLocksByEntityId = function(documentId) {
      var document, locks;
      locks = new Rx.Subject();
      document = new Rx.Subject();
      this.lock.query({
        documentId: documentId
      }, function(response) {
        locks.onNext(response);
        return locks.onCompleted();
      });
      this.document.get({
        documentId: documentId
      }, function(response) {
        document.onNext(response.data);
        return document.onCompleted();
      });
      return Rx.Observable.forkJoin([locks, document]);
    };

    return LockAPI;

  })();

}).call(this);
