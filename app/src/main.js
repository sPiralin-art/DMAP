import { createApp } from "vue";
import ElementPlus from "element-plus";
import { useDark, useToggle } from "@vueuse/core";
import * as Icons from "@element-plus/icons";
import "element-plus/dist/index.css";
import "element-plus/theme-chalk/dark/css-vars.css";
import App from "./App.vue";
import "./assets/main.css";

const app = createApp(App);
const isDark = useDark();
const toggleDark = useToggle(isDark);

Object.keys(Icons).forEach((key) => {
  app.component(key, Icons[key]);
});
app.use(ElementPlus, { size: "small", zIndex: 3000 });
app.mount("#app");
