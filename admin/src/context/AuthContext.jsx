import { createContext, useContext, useEffect, useMemo, useState } from "react";

const AuthContext = createContext(null);

function readStoredUser() {
  try {
    const raw = localStorage.getItem("admin_user");
    return raw ? JSON.parse(raw) : null;
  } catch {
    localStorage.removeItem("admin_user");
    localStorage.removeItem("admin_token");
    return null;
  }
}

export function AuthProvider({ children }) {
  const [token, setToken] = useState(localStorage.getItem("admin_token"));
  const [user, setUser] = useState(() => {
    return readStoredUser();
  });

  useEffect(() => {
    if (token) {
      localStorage.setItem("admin_token", token);
    } else {
      localStorage.removeItem("admin_token");
    }
  }, [token]);

  useEffect(() => {
    if (user) {
      localStorage.setItem("admin_user", JSON.stringify(user));
    } else {
      localStorage.removeItem("admin_user");
    }
  }, [user]);

  const value = useMemo(
    () => ({
      token,
      user,
      login(authData) {
        setToken(authData.token);
        setUser(authData.user);
      },
      logout() {
        setToken(null);
        setUser(null);
      },
    }),
    [token, user]
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export const useAuth = () => useContext(AuthContext);
