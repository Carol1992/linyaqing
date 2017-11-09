<template>
<div class="mycheckbox">
  <div style="border-bottom: 1px solid #e9e9e9;padding-bottom:6px;margin-bottom:6px;">
    <Checkbox
      :indeterminate="indeterminate"
      :value="checkAll"
      @click.prevent.native="handleCheckAll">全选</Checkbox>
  </div>
  <CheckboxGroup v-model="emailSettings" @on-change="checkAllGroupChange">
    <Checkbox label="1"><span>更改用户信息邮件通知</span></Checkbox>
    <Checkbox label="2"><span>关注的作者有作品更新时邮件通知</span></Checkbox>
    <Checkbox label="3"><span>商店有新品上架时邮件通知</span></Checkbox>
    <Checkbox label="4"><span>每日最热图片推送</span></Checkbox>
    <Checkbox label="5"><span>好友关系互动邮件通知</span></Checkbox>
    <Checkbox label="6"><span>每日精选推送</span></Checkbox>
  </CheckboxGroup>
</div>
</template>
<script>
  export default {
    data () {
      return {
        indeterminate: true,
        checkAll: false
      }
    },
    methods: {
      handleCheckAll () {
        if (this.indeterminate) {
          this.checkAll = false
        } else {
          this.checkAll = !this.checkAll
        }
        this.indeterminate = false
        let emailSettings = ''
        if (this.checkAll) {
          emailSettings = ['1', '2', '3', '4', '5', '6']
        } else {
          emailSettings = []
        }
        this.$store.commit('UpdateEmailSettings', emailSettings.toString())
      },
      checkAllGroupChange (data) {
        if (data.length === 6) {
          this.indeterminate = false
          this.checkAll = true
        } else if (data.length > 0) {
          this.indeterminate = true
          this.checkAll = false
        } else {
          this.indeterminate = false
          this.checkAll = false
        }
        this.$store.commit('UpdateEmailSettings', data.toString())
      }
    },
    computed: {
      emailSettings: {
        get: function () {
          return this.$store.state.emailSettings.split(',') || []
        },
        set: function (newValue) {}
      }
    }
  }
</script>

<style scoped>
  .ivu-checkbox-group-item{
    display: block;
    height: 50px;
  }
  .ivu-checkbox-wrapper {
    font-size: 16px;
  }
</style>
