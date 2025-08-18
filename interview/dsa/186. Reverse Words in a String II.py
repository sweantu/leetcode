class Solution:
    def reverseWords(self, s: list[str]) -> None:
        """
        Do not return anything, modify s in-place instead.
        """

        def reverse(s: list[str], left: int, right: int) -> None:
            while left < right:
                s[left], s[right] = s[right], s[left]
                left += 1
                right -= 1

        reverse(s, 0, len(s) - 1)
        i = j = 0
        while j < len(s):
            if s[j] == " ":
                reverse(s, i, j - 1)
                i = j + 1
            j += 1
        reverse(s, i, j - 1)


s = ["t", "h", "e", " ", "s", "k", "y", " ", "i", "s", " ", "b", "l", "u", "e"]
# ["b","l","u","e"," ","i","s"," ","s","k","y"," ","t","h","e"]
Solution().reverseWords(s)
print(f"s3 is {s}")
