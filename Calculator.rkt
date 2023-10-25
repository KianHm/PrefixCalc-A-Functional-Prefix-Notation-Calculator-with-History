#lang racket

;Returns a #t or #f if a character is an operator
(define (char-operator? char)
  (cond
    [(eqv? char #\+) #t]
    [(eqv? char #\-) #t]
    [(eqv? char #\*) #t]
    [(eqv? char #\/) #t]
	[else #f]
    )
  )

;FORMAT:
;   All numbers are separated by spaces
;   Adjacent operators are not separated by spaces
;   There cannot be a space separating an operator and a number (if the operator is on the left, and the number is on the right)
;   There can be a space separating an operator and a number if the operator is on the right and the number is on the left

  ;If the current character is $
  ;   If the last character was an operator, whitespace, or -, add current character to new string
  ;   If the last character is a number, add a space to new string, then add $
  ;If the current character is -
  ;   If the last character was an operator or whitespace, add current character to new string
  ;   If the last operator was a number, add a space to the new string, then add -
  ;If the current character is a number
  ;   Add the number to the new string
  ;If the current character is an operator
  ;   If the last character was an operator or whitespace, then add current character to new string
  ;   If the last character was a number, add a space to the new string, then add current character to new string

(define (format-correctly expr last_char result)
  (if (empty? expr)
	(list->string result)
	(let [(c (car expr))]
	  (cond
		[(empty? last_char) (format-correctly (cdr expr) c (append result (list c)))]
		[(eqv? c #\$)
		 (if (or (char-operator? last_char) (char-whitespace? last_char) (eqv? last_char #\-))
		   (format-correctly (cdr expr) c (append result (list c)))
		   (format-correctly (cdr expr) c (append result '(#\space) (list c)))
		   )
		 ]
		[(eqv? c #\-)
		 (if (or (char-operator? last_char) (char-whitespace? last_char))
		   (format-correctly (cdr expr) c (append result (list c)))
		   (format-correctly (cdr expr) c (append result '(#\space) (list c)))
		   )
		 ]
		[(char-numeric? c)
		 (format-correctly (cdr expr) c (append result (list c)))
		 ]
		[(char-operator? c)
		 (if (or (char-operator? last_char) (char-whitespace? last_char))
		   (format-correctly (cdr expr) c (append result (list c)))
		   (format-correctly (cdr expr) c (append result '(#\space) (list c)))
		   )
		 ]
		[(char-whitespace? c) (format-correctly (cdr expr) c (append result (list c)))]
		[else (begin
				(display "Unexpected trailing characters")
				(ask-input '())
				)]
		)
	  )
	)
  )


#| (define input (read-line)) |#


;Gets a number from the history
(define (get_number_from_memory hist num)
  (define (get_num hist iterator)
	(if (eqv? iterator 1)
	  (car hist)
	  (get_num (cdr hist) (- iterator 1))
	  )
	)
  (get_num hist num)
  )

;Converts a list of number characters into an actual number
(define (convert_to_number lst_number)
  (string->number (list->string lst_number))
  )

;Converts a list of strings to a list of numbers and operators
(define (string_list_to_num_list lst hist)
  (define (convert lst converted number hist memnum negflag)
    (if (empty? lst)
	  (if (not (empty? number))
		(if (not (empty? memnum))
		  ;The last argument is a memory number
		  (if (empty? negflag)
			(convert '() (append converted (list (get_number_from_memory hist (convert_to_number number)))) '() hist '() '())
			(convert '() (append converted (list (- 0 (get_number_from_memory hist (convert_to_number number))))) '() hist '() '())
			)
		  ;The last argument is a regular number
		  (if (empty? negflag)
			(convert '() (append converted (list (convert_to_number number))) '() hist '() '())
			(convert '() (append converted (list (- 0 (convert_to_number number)))) '() hist '() '())
			)
		  )
		converted
		)
        (let ((c (car lst)))
           (cond
              [(char-numeric? c) (convert (cdr lst) converted (append number (list c)) hist memnum negflag)]
			  [(eqv? c #\$) (convert (cdr lst) converted '() hist '(1) negflag)]
			  [(char-whitespace? c) 
			   (if (empty? memnum)
				 ;Not a memory number
				 (if (empty? negflag)
					(convert (cdr lst) (append converted (list (convert_to_number number))) '() hist '() '())
					(convert (cdr lst) (append converted (list (- 0 (convert_to_number number)))) '() hist '() '())
				   )
				 ;If the memnum flag is up, then the number is referencing memory
				 (if (empty? negflag)
					(convert (cdr lst) (append converted (list (get_number_from_memory hist (convert_to_number number)))) '() hist '() '())
					(convert (cdr lst) (append converted (list (- 0 (get_number_from_memory hist (convert_to_number number))))) '() hist '() '())
				   )
				 )
			   ]
			  ;Put the negative flag up if we encounter a -
			  [(eqv? c #\-) (convert (cdr lst) converted '() hist '() '(1))]
              [else (convert (cdr lst) (append converted (list c)) '() hist '() '())]
              ))
    )
  )
  (convert lst '() '() hist '() '())
  )

;Performs an Operation with 2 operands, returns a new stack
(define (perform_op op stack)
  (let ((opr1 (car (reverse stack)))
        (opr2 (car (cdr (reverse stack))))
        (new_stack (reverse (cdr (cdr (reverse stack)))))){
                                                           cond
                                                             [(eqv? op #\+) (append new_stack (list (+ opr1 opr2)))]
                                                             [(eqv? op #\*) (append new_stack (list (* opr1 opr2)))]
                                                             [(eqv? op #\/) 
															  (if (eqv? opr2 0)
																(begin
																  (display "Invalid expression")
																  (ask-input '())
																  )
																(append new_stack (list (/ opr1 opr2)))
																)
															  ]
          })
  )

;Converts string to all upper case characters
(define (to_upper str)
  (define (to_up char result)
	(if (empty? char)
	  (list->string result)
	  (if (char-upper-case? (car char))
		(to_up (cdr char) (append result (list (car char))))
		(to_up (cdr char) (append result (list (integer->char (- (char->integer (car char)) 32)))))
		)
	  )
	)
  (to_up (string->list str) '())
  )

(define (ask-input hist)
	(display "\nEnter expression: ")
	(define input (read-line))
	(cond
	  [(string=? "QUIT" (to_upper input)) (exit '(1))]
	  [(empty? hist) (evaluate_expression ( reverse (string_list_to_num_list (string->list (format-correctly (string->list input) '() '())) '())) '())]
	  [else (evaluate_expression ( reverse (string_list_to_num_list (string->list (format-correctly (string->list input) '() '())) hist)) hist)])
  )

#| (format-correctly (string->list input) '() '()) |#

;String for result format
(define (get-result-string id num)
  (string-append (number->string id) ": " (number->string num))
  )

;Evaluates Expression
(define (evaluate_expression expr hist)
  (define (eval expr stack hist)
    (if (empty? expr)
	  (cond
		[(empty? stack) (begin (display "Invalid expression") (ask-input '()))]
		[(> (length stack) 1) (begin (display "Unexpected trailing characters") (ask-input '()))]
        [else (begin (display (get-result-string (+ 1 (length hist)) (car stack))) (ask-input (append hist (list (car stack)))))]
		)
        (cond
          [(number? (car expr)) (eval (cdr expr) (append stack (list (car expr))) hist)]
		  [(char-operator? (car expr))
		   (if (< (length stack) 2)
			 (begin
			   (display "Invalid expression")
			   (ask-input '())
			   )
			 (eval (cdr expr) (perform_op (car expr) stack) hist)
			 )
		   ]
		  [else
			(begin
			  (display "Unexpected trailing characters")
			  (ask-input '())
			  )
			]
          #| [else (eval [cdr expr] |#
          #|             [perform_op (car expr) stack] |#
					  #| hist |#
          #|             )] |#
          )
        )
    )
  (eval expr '() hist)
  )

(ask-input '())

;Test Cases
;**$3$2$1
;/+++80 100 90 79 4
;/++/85 90 /78 90 /84 90 3
;+100$2
;+/*$1 40 100 /*$3 60 100
;+$1-1
;*$1$1
;+$3-1
;*$3$3
;+$5-1
;*$5$5
;+$7-1
;*/17 100 215
;+215-$1
;*/40 100 $2
;+$2-$3
