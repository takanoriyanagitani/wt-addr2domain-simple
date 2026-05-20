(module

  (memory (export "memory") 1)

  (func $addr2domain (export "addr2domain")
    (param $ptr_lbi i32)
    (param $ptr_ube i32)
    (result i32)

    ;; input 1: ptr to the start of the string(inclusive)
    ;; input 2: ptr to the end of the string(exlusive)
    ;; output when @ found: the ptr to the char after the '@'
    ;; output when missing: 0
    ;; example: "hi@example.com"
    ;;           0123456789abcde
    ;;           ^  ^          ^ 
    ;;           |  |          | 
    ;;           |  |          |___ ptr_ube 
    ;;           |  |___ return ptr
    ;;           |__ ptr_lbi

    (local $ptr i32)

    local.get $ptr_lbi
    local.set $ptr

    loop ;; 0
      local.get $ptr
      local.get $ptr_ube
      i32.ge_u
      if
        i32.const 0
        return
      end

      local.get $ptr
      i32.load8_u
      i32.const 0x0000_0040
      i32.eq
      if
        local.get $ptr
        i32.const 1
        i32.add
        return
      end

      i32.const 1
      local.get $ptr
      i32.add
      local.set $ptr

      br 0
    end

    i32.const 0
  )
)
