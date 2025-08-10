class Solution:
    def isOneEditDistance(self, s: str, t: str) -> bool:
        if abs(len(s) - len(t)) > 1:
            return False

        if len(s) > len(t):
            s, t = t, s

        i = j = diff = 0
        while i < len(s) and j < len(t):
            if s[i] != t[j]:
                diff += 1
                if diff > 1:
                    return False
                if len(s) < len(t):
                    j += 1
                    continue
            i += 1
            j += 1

        return diff == 1 or (diff == 0 and len(s) + 1 == len(t))


class Solution2:
    def isOneEditDistance(self, s: str, t: str) -> bool:
        if s == t:
            return False
        if len(s) > len(t):
            s, t = t, s
        m, n = len(s), len(t)
        if n - m > 1:
            return False
        for i in range(m):
            if s[i] != t[i]:
                if m < n:
                    return s[i:] == t[i + 1 :]
                else:
                    return s[i + 1 :] == t[i + 1 :]
        return False


s = "ab"
t = "abc"

print(Solution2().isOneEditDistance(s, t))
