type 'a lazy_list = Nil | LazyList of 'a * (unit -> 'a lazy_list)
