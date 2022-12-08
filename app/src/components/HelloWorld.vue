<script setup>
import WelcomeItem from "./WelcomeItem.vue";
// import DocumentationIcon from "./icons/IconDocumentation.vue";
// import ToolingIcon from "./icons/IconTooling.vue";
// import EcosystemIcon from "./icons/IconEcosystem.vue";
// import CommunityIcon from "./icons/IconCommunity.vue";
// import SupportIcon from "./icons/IconSupport.vue";
</script>

<template>
  <WelcomeItem>
    <template #icon>
      <img class="logo" src="../assets/logo.png" width="30" height="30" />
    </template>
    <template #heading>DMAP</template>
    A Collective Creation by All Web3 Users.
  </WelcomeItem>
  <WelcomeItem>
    <template #icon>
      <el-icon :size="30" :color="'#898d90'">
        <Clock />
      </el-icon>
    </template>
    <template #heading>Mint in:</template>
    {{ count }}
  </WelcomeItem>
  <WelcomeItem>
    <template #icon>
      <el-icon :size="30" :color="'#898d90'">
        <Platform />
      </el-icon>
    </template>
    <template #heading>Account:</template>

    <el-select
      v-model="value"
      placeholder="Please select an account"
      @change="
        (value) => {
          changeValue(value);
        }
      "
    >
      <el-option
        v-for="item in accountlist"
        :key="item"
        :label="item"
        :value="item"
      >
      </el-option>
    </el-select>
  </WelcomeItem>

  <WelcomeItem>
    <template #icon>
      <el-icon :size="30" :color="'#898d90'">
        <Money />
      </el-icon>
    </template>
    <template #heading>Balance:</template>
    {{ balance }}
  </WelcomeItem>

  <WelcomeItem>
    <template #icon>
      <el-icon :size="30" :color="'#898d90'">
        <Picture />
      </el-icon>
    </template>
    <template #heading>Paint a Pixel: </template>
    <p v-if="CDofPainter >= 0">⏰ {{ cdcount }}</p>
    <el-row>
      <el-space class="margin">
        <el-input placeholder="x" v-model="positionx"
          ><template #prepend>x</template></el-input
        >
        <el-input placeholder="y" v-model="positiony"
          ><template #prepend>y</template></el-input
        >
      </el-space>
    </el-row>
    <el-row>
      <el-radio-group class="margin" v-model="checkboxGroup1" size="small">
        <el-space wrap="true" :size="2">
          <el-radio
            class="pad"
            border
            v-for="(a, i) in colors"
            :key="i"
            :label="a"
            :style="{ background: a }"
            @change="selectcolor(i)"
          >
            <p></p>
          </el-radio>
        </el-space>
      </el-radio-group>
    </el-row>
    <el-row>
      <el-popover
        v-if="CDofPainter >= 0"
        placement="bottom-start"
        title="Cooling down"
        trigger="hover"
        content="Each account only paint every 5 minutes."
      >
        <template #reference>
          <el-button type="warning">CoolDown</el-button>
        </template>
      </el-popover>
      <el-popover
        v-else
        placement="bottom-start"
        title="Paint"
        trigger="hover"
        content="Paint the selected pixel to the color you chose. This will cost gas fee!"
      >
        <template #reference>
          <el-button @click="PaintPixel" type="success">Paint</el-button>
        </template>
      </el-popover>
    </el-row>
  </WelcomeItem>
</template>

<script>
import Web3 from "web3";
import PaintingContractABI from "../../../build/contracts/Painting.json"; // 引入 Truffle 编译后的合约文件
import { ref } from "vue";
export default {
  name: "MSHK.TOP",
  data() {
    return {
      ContractABI: PaintingContractABI, // 调用 智能合约的 JSON 接口
      msg: "",
      GanacheUrl: "localhost:7545",
      CurrentAccount: null,
      NewContract: null,
      options: [],
      balance: 0,
      value: "",
      accountlist: [],
      positionx: 0,
      positiony: 0,
      CDofPainter: -99999,
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
      color: 15,
      checkboxGroup1: ref("#ffffff"),
      count: "", //倒计时
      seconds: 864000, // 10天的秒数
      cdcount: "",
    };
  },
  methods: {
    async readAccount() {
      var obj = this;
      var tempaccountlist = await this.web3.eth.getAccounts();
      obj.accountlist = tempaccountlist;
      var contract = new this.web3.eth.Contract(
        this.ContractABI.abi,
        "0x54d9A759B47af7d9D58F131C709Dd4Fb57063C01"
      );
      var CD = await contract.methods.CDofPainter(this.value).call();
      var temp = await contract.methods.getfinishtime().call();
      var timestamp = new Date().getTime();
      obj.seconds = temp - timestamp / 1000;
      var CDofPainter = CD - timestamp / 1000;
      obj.CDofPainter = CDofPainter;
    },

    // async readContract() {
    //   // 读取合约
    //   var obj = this;
    //   // 使用 JSON 接口、合约地址，创建一个新的合约实例，其所有方法和事件都在其json 接口对象中定义。
    //   var contract = new this.web3.eth.Contract(
    //     this.ContractABI.abi,
    //     "0x54d9A759B47af7d9D58F131C709Dd4Fb57063C01"
    //   );
    //   var CD = await contract.methods.CDofPainter(this.value).call();
    //   var temp = await contract.methods.getfinishtime().call();
    //   var timestamp = new Date().getTime();
    //   obj.seconds = temp - timestamp / 1000;
    //   console.log(CD);
    // },

    async changeValue(value) {
      var obj = this;
      obj.balance =
        (await this.web3.eth.getBalance(value)) / 1000000000000000000 + " ETH";
      obj.CurrentAccount = value;
      this.readAccount();
    },

    selectcolor(value) {
      var obj = this;
      obj.color = value;
      console.log(value);
    },

    async PaintPixel() {
      var obj = this;
      console.log(obj.value);
      var contract = new this.web3.eth.Contract(
        this.ContractABI.abi,
        "0x54d9A759B47af7d9D58F131C709Dd4Fb57063C01"
      );
      var temp = await contract.methods
        .paint(obj.positionx, obj.positiony, obj.color)
        .send({
          from: obj.value,
          gas: 6721975,
        });
      this.readAccount();
    },
    countDown() {
      let d = parseInt(this.seconds / (24 * 60 * 60));
      d = d < 10 ? "0" + d : d;
      let h = parseInt((this.seconds / (60 * 60)) % 24);
      h = h < 10 ? "0" + h : h;
      let m = parseInt((this.seconds / 60) % 60);
      m = m < 10 ? "0" + m : m;
      let s = parseInt(this.seconds % 60);
      s = s < 10 ? "0" + s : s;
      this.count =
        d + " Days " + h + " Hours " + m + " Minutes " + s + " Seconds";
    },
    CD() {
      let m = parseInt((this.CDofPainter / 60) % 60);
      m = m < 10 ? "0" + m : m;
      let s = parseInt(this.CDofPainter % 60);
      s = s < 10 ? "0" + s : s;
      this.cdcount = m + " : " + s;
    },
    //定时器没过1秒参数减1
    Time() {
      setInterval(() => {
        this.seconds -= 1;
        this.CDofPainter -= 1;
        this.countDown();
        this.CD();
      }, 1000);
    },
  },
  mounted() {
    // if (typeof this.web3 !== "undefined") {
    //   // web3.currentProvider当前提供者
    //   this.web3 = new Web3(this.web3.currentProvider);
    // } else {
    //   // set the provider you want from Web3.providers
    //   this.web3 = new Web3("http://" + this.GanacheUrl);
    // }

    this.web3 = new Web3("ws://" + this.GanacheUrl);
    this.Time();
    this.readAccount();
    // this.readContract();
  },
};
</script>
<style>
.title {
  font-size: large;
  font-weight: bold;
  color: #409eff;
}
.pad {
  width: 28px;
}
.margin {
  margin-bottom: 0.5rem;
  width: 100%;
}
.left_logo {
  padding-right: 6rem;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}
</style>
