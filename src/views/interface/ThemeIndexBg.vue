<template>
  <page-view>
    <a-row :gutter="15">
      <a-col :span="24">
        <a-card :bodyStyle="{ padding: '16px' }" :bordered="false">
          <a-form-model-item label="首页视频上传" prop="field110">
            <div class="clearfix">
              <a-upload :file-list="fileList" :remove="handleRemove" :before-upload="beforeUpload">
                <a-button>
                  <a-icon type="upload" />
                  Select File
                </a-button>
              </a-upload>
              <a-button
                type="primary"
                :disabled="fileList.length === 0"
                :loading="uploading"
                style="margin-top: 16px"
                @click="handleUpload"
              >
                {{ uploading ? 'Uploading' : 'Start Upload' }}
              </a-button>
            </div>
          </a-form-model-item>
        </a-card>
      </a-col>
    </a-row>
  </page-view>
</template>
<script>
import { PageView } from '@/layouts'

export default {
  components: {
    PageView
  },
  props: [],
  data() {
    return {
      formData: {
        field110: null
      },
      rules: {},
      field110Action: 'https://jsonplaceholder.typicode.com/posts/',
      field110fileList: [],
      fileList: [],
      uploading: false
    }
  },
  computed: {},
  watch: {},
  created() {},
  mounted() {},
  methods: {
    handleRemove(file) {
      const index = this.fileList.indexOf(file)
      const newFileList = this.fileList.slice()
      newFileList.splice(index, 1)
      this.fileList = newFileList
    },
    beforeUpload(file) {
      this.fileList = [...this.fileList, file]
      return false
    },
    handleUpload() {
      const { fileList } = this
      const formData = new FormData()
      fileList.forEach(file => {
        formData.append('files[]', file)
      })
      this.uploading = true

      // You can use any AJAX library you like
      // reqwest({
      //   url: 'https://www.mocky.io/v2/5cc8019d300000980a055e76',
      //   method: 'post',
      //   processData: false,
      //   data: formData,
      //   success: () => {
      //     this.fileList = []
      //     this.uploading = false
      //     this.$message.success('upload successfully.')
      //   },
      //   error: () => {
      //     this.uploading = false
      //     this.$message.error('upload failed.')
      //   }
      // })
    }
  }
}
</script>
<style>
.avatar-uploader > .ant-upload {
  width: 128px;
  height: 128px;
}

.ant-upload-select-picture-card i {
  font-size: 32px;
  color: #999;
}

.ant-upload-select-picture-card .ant-upload-text {
  margin-top: 8px;
  color: #666;
}
</style>
