class @LockAPI
  constructor: (Lock, Document) ->
    @lock = Lock
    @document = Document
 
  getLocksByEntityId: (documentId) ->
    locks = new Rx.Subject()
    document = new Rx.Subject()
      
    @lock.query({documentId: documentId}, (response) ->
      locks.onNext response
      locks.onCompleted()
    )
        
    @document.get({documentId: documentId}, (response) ->
      document.onNext response.data
      document.onCompleted()
    )
      
    Rx.Observable.forkJoin [locks, document]
    
  
      
      