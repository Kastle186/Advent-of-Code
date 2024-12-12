;; Day11.el: My solution in Emacs Lisp!

(defun main (input-file)
  "Main function of our script!"
  ;; Read list of pebbles from the input file. It expects only one line of input.
  (setq pebbles-list (with-temp-buffer
                       (insert-file-contents input-file)
                       (mapcar (lambda (x) (string-to-number x))
                               (split-string (buffer-string)))))

  ;; Total blinks!
  (defconst num-blinks 75)

  ;; Apply the algorithm the number of times the problem asks.
  (dotimes (i num-blinks)
    (message "Iteration: %s" (+ i 1))
    (setq pebbles-list (apply-plutonian-blink pebbles-list))

    ;; PART ONE! ;;
    (when (= i 24)
      (message "PART ONE: %s" (length pebbles-list))))

  ;; PART TWO! ;;
  (message "PART TWO: %s" (length pebbles-list)))

;; HELPER FUNCTIONS! ;;

(defun apply-plutonian-blink (pebbles-list)
  "Apply the algorithm of the Plutonian Pebbles spacetime manipulation:
- If engraved with number 0, then it becomes engraved with number 1.
- If engraved with an even number of digits, split it into two halves.
- If none of the above, then multiply its number by 2024."
  (flatten-tree (mapcar (lambda (x) (cond ((= x 0) 1)
                                          ((= (% (num-digits x) 2) 0) (split-num-halves x))
                                          (t (* x 2024))))
                        pebbles-list)))

(defun num-digits (number)
  "Calculates and returns the total number of digits in the given integer."
  (length (number-to-string number)))

(defun split-num-halves (number)
  "Split the given number into two containing each one half of its digits."
  (let* ((num-str (number-to-string number))
         (str-size (length num-str))
         (half-size (/ str-size 2)))

    ;; Make a list of substrings with each half and map them to numbers.
    (mapcar (lambda (x) (string-to-number x))
            (list (substring num-str 0 half-size) (substring num-str half-size str-size)))))

(main (nth 3 command-line-args))
