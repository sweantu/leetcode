class Solution:
    def isOneEditDistance(self, s: str, t: str) -> bool:
        if s == t:
            return False
        if len(s) > len(t):
            s, t = t, s
        m, n = len(s), len(t)
        if n - m > 1:
            return False
        i = j = d = 0
        while i < m and j < n:
            if s[i] != t[j]:
                d += 1
                if d > 1:
                    return False
                if m < n:
                    j += 1
                    continue
            i += 1
            j += 1

        return d <= 1


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
        return True


s = "ab"
t = "abc"

print(Solution2().isOneEditDistance(s, t))
