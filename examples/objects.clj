(def user {"name" "honza"
           "age" 24})

(console.log (get user "name")) ;; "honza"
(console.log (update user "name" "nobody"))
;; => { name: 'nobody', age: 24 }

(console.log user)
;; => { name: 'honza', age: 24 }
