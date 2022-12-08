<script setup>
import { onMounted } from "vue";
import HelloWorld from "./components/HelloWorld.vue";
import TheWelcome from "./components/TheWelcome.vue";
</script>

<template>
  <header>
    <!-- <div class="left_logo">
      <img class="logo" src="./assets/logo.png" width="125" height="125" />
      <p style="width: 100%; text-align: center">
        DMAP - Collective Creation by All Web3 Users.
      </p>
    </div> -->
    <div class="wrapper">
      <TheWelcome />
    </div>
  </header>

  <main class="mm">
    <div style="width: 80%">
      <HelloWorld />
    </div>
  </main>
  <footer>Made by © 120090396 Li Hanlin</footer>
  <!-- <el-row>
    <el-col class="mark" :span="8">
      <img src="./assets/logo.png" width="125" height="125" />
      <p>DMAP -- A collective creation made by all web3 users.</p>
    </el-col>
    <el-col class="mark" :span="8">
      <HelloWorld />
    </el-col>
    <el-col class="mark" :span="8">
      <TheWelcome />
    </el-col>
  </el-row> -->
</template>
<style scoped>
header {
  line-height: 1.5;
}

@media (min-width: 1024px) {
  header {
    display: flex;
    place-items: center;
    padding-right: calc(var(--section-gap) / 4);
  }

  .left_logo {
    padding-right: 6rem;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
  }

  header .wrapper {
    display: flex;
    place-items: flex-start;
    flex-wrap: wrap;
  }

  .mm {
    display: flex;
    flex-direction: column;
    place-items: flex-end;
  }
}
</style>
