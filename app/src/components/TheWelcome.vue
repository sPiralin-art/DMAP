<script setup>
// import WelcomeItem from "./WelcomeItem.vue";
// import DocumentationIcon from "./icons/IconDocumentation.vue";
// import ToolingIcon from "./icons/IconTooling.vue";
// import EcosystemIcon from "./icons/IconEcosystem.vue";
// import CommunityIcon from "./icons/IconCommunity.vue";
// import SupportIcon from "./icons/IconSupport.vue";
</script>

<template>
  <canvas id="myCanvas" style="border: 1px solid #000"> </canvas>
  <!-- <WelcomeItem>
    <template #icon>
      <DocumentationIcon />
    </template>
    <template #heading>Documentation</template>

    Vue’s
    <a href="https://vuejs.org/" target="_blank" rel="noopener">official documentation</a>
    provides you with all information you need to get started.
  </WelcomeItem>

  <WelcomeItem>
    <template #icon>
      <ToolingIcon />
    </template>
    <template #heading>Tooling</template>

    This project is served and bundled with
    <a href="https://vitejs.dev/guide/features.html" target="_blank" rel="noopener">Vite</a>. The
    recommended IDE setup is
    <a href="https://code.visualstudio.com/" target="_blank" rel="noopener">VSCode</a> +
    <a href="https://github.com/johnsoncodehk/volar" target="_blank" rel="noopener">Volar</a>. If
    you need to test your components and web pages, check out
    <a href="https://www.cypress.io/" target="_blank" rel="noopener">Cypress</a> and
    <a href="https://on.cypress.io/component" target="_blank">Cypress Component Testing</a>.

    <br />

    More instructions are available in <code>README.md</code>.
  </WelcomeItem>

  <WelcomeItem>
    <template #icon>
      <EcosystemIcon />
    </template>
    <template #heading>Ecosystem</template>

    Get official tools and libraries for your project:
    <a href="https://pinia.vuejs.org/" target="_blank" rel="noopener">Pinia</a>,
    <a href="https://router.vuejs.org/" target="_blank" rel="noopener">Vue Router</a>,
    <a href="https://test-utils.vuejs.org/" target="_blank" rel="noopener">Vue Test Utils</a>, and
    <a href="https://github.com/vuejs/devtools" target="_blank" rel="noopener">Vue Dev Tools</a>. If
    you need more resources, we suggest paying
    <a href="https://github.com/vuejs/awesome-vue" target="_blank" rel="noopener">Awesome Vue</a>
    a visit.
  </WelcomeItem>

  <WelcomeItem>
    <template #icon>
      <CommunityIcon />
    </template>
    <template #heading>Community</template>

    Got stuck? Ask your question on
    <a href="https://chat.vuejs.org" target="_blank" rel="noopener">Vue Land</a>, our official
    Discord server, or
    <a href="https://stackoverflow.com/questions/tagged/vue.js" target="_blank" rel="noopener"
      >StackOverflow</a
    >. You should also subscribe to
    <a href="https://news.vuejs.org" target="_blank" rel="noopener">our mailing list</a> and follow
    the official
    <a href="https://twitter.com/vuejs" target="_blank" rel="noopener">@vuejs</a>
    twitter account for latest news in the Vue world.
  </WelcomeItem>

  <WelcomeItem>
    <template #icon>
      <SupportIcon />
    </template>
    <template #heading>Support Vue</template>

    As an independent project, Vue relies on community backing for its sustainability. You can help
    us by
    <a href="https://vuejs.org/sponsor/" target="_blank" rel="noopener">becoming a sponsor</a>.
  </WelcomeItem> -->
</template>
<script>
import Web3 from "web3";
import PaintingContractABI from "../../../build/contracts/Painting.json"; // 引入 Truffle 编译后的合约文件
export default {
  data() {
    return {
      ContractABI: PaintingContractABI, // 调用 智能合约的 JSON 接口
      msg: "",
      size: 128,
      GanacheUrl: "localhost:7545",
      NewContract: null,
      PaintingSize: "500",
      contractaddr: "0x8Ba60d98946f0410906a9CEb0B1240172be44633",
      colors: [
        "#ff4500",
        "#ffa800",
        "#ffd635",
        "#00a368",
        "#7eed56",
        "#2450a4",
        "#3690ea",
        "#51e9f4",
        "#811e9f",
        "#b44ac0",
        "#ff99aa",
        "#9c6926",
        "#000000",
        "#898d90",
        "#d4d7d9",
        "#ffffff",
      ],
    };
  },
  mounted() {
    // if (typeof this.web3 !== "undefined") {
    //   // web3.currentProvider当前提供者
    //   this.web3 = new Web3(this.web3.currentProvider);
    // } else {
    //   // set the provider you want from Web3.providers
    //   this.web3 = new Web3("http://" + this.GanacheUrl);
    // }
    var obj = this;
    this.web3 = new Web3("ws://" + this.GanacheUrl);

    var subscription = this.web3.eth
      .subscribe(
        "logs",
        {
          address: obj.contractaddr,
          topics: [
            "0x7087c0425f2117d8d78d7f3022e3b3f1de72d08d6f83d92d544ee221a3a0538b",
          ],
        },
        function (error, result) {
          console.log(result);
          console.log(error);
        }
      )
      .on("connected", function (subscriptionId) {
        console.log(subscriptionId);
      })
      .on("data", function (log) {
        console.log("Someone painted just now!" + log);
        obj.loadPainting();
      })
      .on("changed", function (log) {});

    this.initCancas();
    this.loadPainting();
    // var events = this.web3.eth.abi.encodeEventSignature({
    //   anonymous: false,
    //   inputs: [
    //     {
    //       indexed: true,
    //       internalType: "address",
    //       name: "from",
    //       type: "address",
    //     },
    //     {
    //       indexed: false,
    //       internalType: "uint256",
    //       name: "color",
    //       type: "uint256",
    //     },
    //   ],
    //   name: "Painted",
    //   type: "event",
    // });
    // console.log(events); //0x7087c0425f2117d8d78d7f3022e3b3f1de72d08d6f83d92d544ee221a3a0538b
  },
  methods: {
    initCancas() {
      let obj = this;
      console.log("初始化canvas");
      let canvas = document.getElementById("myCanvas");
      let ctx = canvas.getContext("2d");
      canvas.width = this.PaintingSize;
      canvas.height = this.PaintingSize;
      let width = canvas.width,
        height = canvas.height;
      if (window.devicePixelRatio) {
        canvas.style.width = width + "px";
        canvas.style.height = height + "px";
        canvas.height = height * window.devicePixelRatio;
        canvas.width = width * window.devicePixelRatio;
        ctx.scale(window.devicePixelRatio, window.devicePixelRatio);
      }
      ctx.imageSmoothingEnabled = false;
      ctx.fillStyle = this.colors[15];
      // ctx.fillRect(0, 0, 600, 600);
    },

    CancasPaint(x, y, color) {
      let canvas = document.getElementById("myCanvas");
      let ctx = canvas.getContext("2d");
      ctx.fillStyle = this.colors[color];
      ctx.fillRect(
        x * (this.PaintingSize / this.size),
        y * (this.PaintingSize / this.size),
        this.PaintingSize / this.size,
        this.PaintingSize / this.size
      );
    },

    async loadPainting() {
      var obj = this;
      // 使用 JSON 接口、合约地址，创建一个新的合约实例，其所有方法和事件都在其json 接口对象中定义。
      var contract = new this.web3.eth.Contract(
        this.ContractABI.abi,
        this.contractaddr,
      );
      var temp = await contract.methods.getsize().call();
      obj.size = temp;
      var pixels = await contract.methods.getpixels().call();
      console.log(pixels);
      for (var i in pixels) {
        // console.log(pixels[i]);
        this.CancasPaint(pixels[i].x, pixels[i].y, pixels[i].color);
      }
      // for (var x = 0; x < temp; x = x + 1) {
      //   for (var y = 0; y < temp; y = y + 1) {
      //     contract.methods
      //       .getData(x, y)
      //       .call()
      //       .then((pixel) => {
      //         if (pixel[0] == "0x0000000000000000000000000000000000000000") {
      //           this.CancasPaint(x, y, 15);
      //         } else {
      //           this.CancasPaint(x, y, pixel[3]);
      //         }
      //       });
      //   }
      // }
    },
  },
};
</script>
