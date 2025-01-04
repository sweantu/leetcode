class Solution:
    def reverseWords(self, s: str) -> str:
        chars = list(s)
        n = len(chars)

        def reverse(start, end):
            while start < end:
                chars[start], chars[end] = chars[end], chars[start]
                start += 1
                end -= 1

        # reverse chars
        reverse(0, n - 1)

        # reverse each words
        i = 0
        while i < n:
            # skip spaces
            while i < n and chars[i] == " ":
                i += 1
            start = i
            # get a word
            while i < n and chars[i] != " ":
                i += 1
            end = i - 1
            # reverse a words
            reverse(start, end)

        # remove spaces
        i, j = 0, 0
        while i < n:
            # ignore first spaces
            while i < n and chars[i] == " ":
                i += 1
            # move word into front
            while i < n and chars[i] != " ":
                chars[j] = chars[i]
                i += 1
                j += 1
            # ignore last spaces
            while i < n and chars[i] == " ":
                i += 1
            # add a space after words
            if i < n:
                chars[j] = " "
                j += 1
        return "".join(chars[:j])


s = "  hello world  "
print(Solution().reverseWords(s))
